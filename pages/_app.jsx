import '../styles/global.css'
import '../styles/page.css'
import Head from 'next/head'

export default function App({ Component, pageProps }) {
  return(
    <>
      <Head>
        <link rel="icon" href="/geovis-portfolio/favicon.ico" />
      </Head>
      <Component {...pageProps} />
    </>
  ) 
}