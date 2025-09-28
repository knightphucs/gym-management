import { navMain } from "@/config/navigation";

export function getBreadcrumbs(pathname: string) {
  for (const item of navMain) {
    // If the parent itself is active
    if (item.url === pathname) {
      return [{ title: item.title, url: item.url }];
    }

    // If one of the children is active
    if (item.items) {
      const sub = item.items.find((s) => s.url === pathname);
      if (sub) {
        return [
          { title: item.title, url: item.url },
          { title: sub.title, url: sub.url },
        ];
      }
    }
  }

  return [];
}
