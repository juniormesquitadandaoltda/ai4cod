/** @type {import('next').NextConfig} */
const withYaml = require('next-plugin-yaml')

const nextConfig = {
  output: 'export',
  images: {
    unoptimized: true
  },
  rewrites: _ => [
    { source: '/data/:path*', destination: 'http://dockerhost:3004/data/:path*' },
    { source: '/admin/swagger/:path*', destination: 'http://dockerhost:3004/admin/swagger/:path*' },
    { source: '/admin/sidekiq/:path*', destination: 'http://dockerhost:3004/admin/sidekiq/:path*' },
    { source: '/letter_opener/:path*', destination: 'http://dockerhost:3004/letter_opener/:path*' }
  ]
}

module.exports = withYaml(nextConfig)
