import { defineConfig } from '@playwright/test'
export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  workers: 2,
  timeout: 45000,
  expect: { timeout: 8000 },
  reporter: 'list',
  use: { baseURL: 'http://127.0.0.1:5176', channel: 'chrome', headless: true, screenshot: 'only-on-failure', trace: 'retain-on-failure' },
  webServer: [
    { command: 'npm run dev:demo -- --port 5176', url: 'http://127.0.0.1:5176', reuseExistingServer: !process.env.CI, timeout: 30000 },
    { command: 'npm run dev:api -- --port 5175', url: 'http://127.0.0.1:5175', reuseExistingServer: !process.env.CI, timeout: 30000 },
  ],
})
