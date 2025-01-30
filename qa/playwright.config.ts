import { defineConfig } from '@playwright/test'

export default defineConfig({
    timeout: 5000,
    use: {
        baseURL: process.env.BASE_URL || 'http://localhost:9000',
        extraHTTPHeaders: {
            'Authorization': `Basic ${process.env.API_TOKEN}`
        }
    },
    reporter: [
        ['list', { printSteps: true }]
    ],
})

