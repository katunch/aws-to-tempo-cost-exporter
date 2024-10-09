import { handler } from './index.mjs';

const event = {};
handler(event).then(console.log).catch(console.error);