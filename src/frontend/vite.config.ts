import { defineConfig } from 'vitest/config';

export default defineConfig({
  server: {
    port: 5173,
    strictPort: true,
    proxy: { '/api': 'http://127.0.0.1:5080' },
  },
  test: {
    include: ['tests/**/*.test.ts'],
    environment: 'node',
  },
});
