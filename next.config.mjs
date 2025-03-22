import nextra from "nextra";

const nextConfig = {
  output: "export",
  reactStrictMode: true,
  images: {
    unoptimized: true,
  },
  basePath: "/geovis-portfolio",
  // async headers() {
  //   return [
  //     {
  //       source: "/geovis-portfolio/favicon.ico",
  //       headers: [
  //         {
  //           key: "Content-Type",
  //           value: "image/x-icon",
  //         },
  //       ],
  //     },
  //   ];
  // },
}

const withNextra = nextra({
  theme: "nextra-theme-docs",
  themeConfig: "./theme.config.jsx",
});

export default withNextra(nextConfig)

// If you have other Next.js configurations, you can pass them as the parameter:
// export default withNextra({ /* other next.js config */ })
