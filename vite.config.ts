import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import FullReload from 'vite-plugin-full-reload'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    FullReload(
      [
        'app/**/*',
        'lib/**/*',
      ],
      { delay: 2000 }
    ),
  ],
})
