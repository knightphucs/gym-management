"use client";

import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb";
import { usePathname } from "next/navigation";
import { getBreadcrumbs } from "@/lib/getBreadcrumbs";

export function AppBreadcrumbs() {
  const pathname = usePathname();
  let crumbs = getBreadcrumbs(pathname);

  if (crumbs.length > 0 && crumbs[0].url === "/dashboard") {
    crumbs = crumbs.slice(1);
  }

  return (
    <Breadcrumb>
      <BreadcrumbList>
        <BreadcrumbItem className="hidden md:block">
          <BreadcrumbLink href="/dashboard">Dashboard</BreadcrumbLink>
        </BreadcrumbItem>

        {crumbs.length > 0 && (
          <BreadcrumbSeparator className="hidden md:block" />
        )}

        {crumbs.map((crumb, idx) => {
          const isLast = idx === crumbs.length - 1;
          return (
            <BreadcrumbItem key={crumb.url}>
              {isLast ? (
                <BreadcrumbPage>{crumb.title}</BreadcrumbPage>
              ) : (
                <>
                  <BreadcrumbLink href={crumb.url}>
                    {crumb.title}
                  </BreadcrumbLink>
                  <BreadcrumbSeparator />
                </>
              )}
            </BreadcrumbItem>
          );
        })}
      </BreadcrumbList>
    </Breadcrumb>
  );
}
