import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  vite: {
    plugins: [
      // Custom configuration for Elm compilation
      {
        name: 'vite-plugin-elm',
        enforce: 'pre',
        apply: 'build',
        async resolveId(source) {
          if (source.endsWith('.elm')) {
            return source;
          }
        },
        async load(id) {
          if (id.endsWith('.elm')) {
            // This would be handled by a proper Elm plugin in a real setup
            console.log(`Processing Elm file: ${id}`);
            return null;
          }
        }
      }
    ]
  }
});