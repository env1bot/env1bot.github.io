import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  site: 'https://env1bot.github.io',
  integrations: [tailwind()],
});
