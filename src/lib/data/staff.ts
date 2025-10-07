import { prisma } from "@/lib/prisma";

export async function getStaffNames() {
  return prisma.staff.findMany({
    select: { id: true, full_name: true },
    orderBy: { full_name: "asc" },
  });
}
