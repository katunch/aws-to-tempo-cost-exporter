import { CostExplorerClient, GetCostAndUsageCommand } from "@aws-sdk/client-cost-explorer";
import axios from "axios";
import { DateTime } from "luxon";

const ce = new CostExplorerClient({ region: 'us-east-1' });

const startOfPreviousMonth = (date) => { 
    const previousMonth = date.minus({ months: 1 });
    return previousMonth.startOf('month');

};
const endOfPreviousMonth = (date) => {
    const previousMonth = date.minus({ months: 1 });
    return previousMonth.endOf('month');
}


export const handler = async (event) => {
    // Get the current date and calculate start and end dates for last month
    const today = DateTime.now();
    const startOfLastMonth = startOfPreviousMonth(today);
    const endOfLastMonth = endOfPreviousMonth(today);

    // Format dates as YYYY-MM-DD
    const startOfLastMonthFormatted = startOfLastMonth.toFormat('yyyy-MM-dd');
    const endOfLastMonthFormatted = endOfLastMonth.toFormat('yyyy-MM-dd');

    // Fetch AWS Costs from Cost Explorer API
    try {

        const costData = await ce.send(new GetCostAndUsageCommand({
            TimePeriod: {
                Start: startOfLastMonthFormatted,
                End: endOfLastMonthFormatted
            },
            Granularity: 'MONTHLY',
            Metrics: ['UnblendedCost']
        }));

        const totalCost = parseFloat(costData.ResultsByTime[0].Total.UnblendedCost.Amount);

        let description = `AWS costs for ${startOfLastMonth.toFormat('LLLL yyyy')}`;
        if (process.env.TEMPO_EXPENSE_DESCRIPTION) {
            description = `${process.env.TEMPO_EXPENSE_DESCRIPTION} ${startOfLastMonth.toFormat('LLLL yyyy')}`;
        }
        // Prepare payload for Tempo Financial API
        const payload = {
            value: totalCost,
            category: process.env.TEMPO_EXPENSE_CATEGORY || 'AWS Costs',
            date: endOfLastMonthFormatted,
            description: description
        };

        // Send the cost data to the Tempo Financial API
        const tempoApiUrl = `https://api.tempo.io/cost-tracker/1/projects/${process.env.TEMPO_PROJECT_ID}/expenses`;
        const tempoApiToken = process.env.TEMPO_API_TOKEN;

        const headers = {
            Authorization: `Bearer ${tempoApiToken}`,
            'Content-Type': 'application/json'
        };

        // Axios POST request
        const response = await axios.post(tempoApiUrl, payload, { headers });

        if (response.status === 200) {
            return {
                statusCode: 200,
                body: `Total cost for last month: $${totalCost}, successfully submitted to Tempo Financial API.`
            };
        } else {
            return {
                statusCode: response.status,
                body: `Failed to submit expense. Tempo Financial API responded with: ${response.data}`
            };
        }

    } catch (error) {
        console.error('Error fetching AWS costs or submitting to Tempo API:', error);
        return {
            statusCode: 500,
            body: 'Internal server error.'
        };
    }
};