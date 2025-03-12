import { HomeIcon, BookOpenIcon } from "@heroicons/react/24/outline";

export default {
  index: {
    title: (
      <div className="flex items-center mr-2">
        <HomeIcon className="h-5 w-5 mr-2" />
        <span className="text-base">Home</span>
      </div>
    ),
    type: 'page',
    theme: {
      layout: 'raw'
    }
  },
  portfolio: {
    title: (
      <div className="flex items-center mr-2">
        <BookOpenIcon className="h-5 w-5 mr-2" />
        <span className="text-base">Portfolio</span>
      </div>
    ),
    type: 'page',
    theme: {
      toc: true
    }
  }
}