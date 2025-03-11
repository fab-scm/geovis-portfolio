import meta from "../../../pages/_meta.js";
import portfolio_meta from "../../../pages/portfolio/_meta.js";
import portfolio_projects_meta from "../../../pages/portfolio/projects/_meta.js";
import portfolio_theory_meta from "../../../pages/portfolio/theory/_meta.js";
import portfolio_tools_meta from "../../../pages/portfolio/tools/_meta.js";
import portfolio_tools_examples_meta from "../../../pages/portfolio/tools/examples/_meta.js";
export const pageMap = [{
  data: meta
}, {
  name: "index",
  route: "/",
  frontMatter: {
    "sidebarTitle": "Index"
  }
}, {
  name: "portfolio",
  route: "/portfolio",
  children: [{
    data: portfolio_meta
  }, {
    name: "introduction",
    route: "/portfolio/introduction",
    frontMatter: {
      "sidebarTitle": "Introduction"
    }
  }, {
    name: "projects",
    route: "/portfolio/projects",
    children: [{
      data: portfolio_projects_meta
    }, {
      name: "flood",
      route: "/portfolio/projects/flood",
      frontMatter: {
        "sidebarTitle": "Flood"
      }
    }, {
      name: "rusle",
      route: "/portfolio/projects/rusle",
      frontMatter: {
        "sidebarTitle": "Rusle"
      }
    }]
  }, {
    name: "theory",
    route: "/portfolio/theory",
    children: [{
      data: portfolio_theory_meta
    }, {
      name: "animation",
      route: "/portfolio/theory/animation",
      frontMatter: {
        "sidebarTitle": "Animation"
      }
    }, {
      name: "cartography",
      route: "/portfolio/theory/cartography",
      frontMatter: {
        "sidebarTitle": "Cartography"
      }
    }, {
      name: "data",
      route: "/portfolio/theory/data",
      frontMatter: {
        "sidebarTitle": "Data"
      }
    }, {
      name: "fundamentals",
      route: "/portfolio/theory/fundamentals",
      frontMatter: {
        "sidebarTitle": "Fundamentals"
      }
    }, {
      name: "introduction",
      route: "/portfolio/theory/introduction",
      frontMatter: {
        "sidebarTitle": "Introduction"
      }
    }, {
      name: "surfaces",
      route: "/portfolio/theory/surfaces",
      frontMatter: {
        "sidebarTitle": "Surfaces"
      }
    }, {
      name: "threeD",
      route: "/portfolio/theory/threeD",
      frontMatter: {
        "sidebarTitle": "Threed"
      }
    }]
  }, {
    name: "tools",
    route: "/portfolio/tools",
    children: [{
      data: portfolio_tools_meta
    }, {
      name: "arcgis",
      route: "/portfolio/tools/arcgis",
      frontMatter: {
        "sidebarTitle": "Arcgis"
      }
    }, {
      name: "comparison",
      route: "/portfolio/tools/comparison",
      frontMatter: {
        "sidebarTitle": "Comparison"
      }
    }, {
      name: "examples",
      route: "/portfolio/tools/examples",
      children: [{
        data: portfolio_tools_examples_meta
      }, {
        name: "thematic",
        route: "/portfolio/tools/examples/thematic",
        frontMatter: {
          "sidebarTitle": "Thematic"
        }
      }, {
        name: "web",
        route: "/portfolio/tools/examples/web",
        frontMatter: {
          "sidebarTitle": "Web"
        }
      }]
    }, {
      name: "qgis",
      route: "/portfolio/tools/qgis",
      frontMatter: {
        "sidebarTitle": "Qgis"
      }
    }]
  }]
}];