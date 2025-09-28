import { SquareTerminal, Bot, BookOpen, Settings2 } from "lucide-react";

export const navMain = [
  {
    title: "Home",
    url: "/dashboard",
    icon: SquareTerminal,
    items: [
      { title: "History", url: "/dashboard/history" },
      { title: "Starred", url: "/dashboard/starred" },
      { title: "Settings", url: "/dashboard/settings" },
    ],
  },
  {
    title: "Members",
    url: "/dashboard/members",
    icon: Bot,
    items: [
      { title: "Genesis", url: "/dashboard/members/genesis" },
      { title: "Explorer", url: "/dashboard/members/explorer" },
      { title: "Quantum", url: "/dashboard/members/quantum" },
    ],
  },
  {
    title: "Staffs",
    url: "/dashboard/staffs",
    icon: BookOpen,
    items: [
      { title: "Introduction", url: "/dashboard/staffs/introduction" },
      { title: "Get Started", url: "/dashboard/staffs/get-started" },
      { title: "Tutorials", url: "/dashboard/staffs/tutorials" },
      { title: "Changelog", url: "/dashboard/staffs/changelog" },
    ],
  },
  {
    title: "Settings",
    url: "/dashboard/settings",
    icon: Settings2,
    items: [
      { title: "General", url: "/dashboard/settings/general" },
      { title: "Team", url: "/dashboard/settings/team" },
      { title: "Billing", url: "/dashboard/settings/billing" },
      { title: "Limits", url: "/dashboard/settings/limits" },
    ],
  },
];
