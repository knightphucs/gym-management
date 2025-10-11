import { prisma } from "@/lib/prisma";

export async function getMembers() {
  return prisma.members.findMany({
    select: {
      id: true,
      full_name: true,
      member_code: true,
      email: true,
      phone: true,
      gender: true,
      date_of_birth: true,
      health_notes: true,
      registration_date: true,
      created_at: true,
      updated_at: true,
    },
    orderBy: { member_code: "desc" },
  });
}

export async function getActiveMembers(is_active: boolean) {
  return prisma.members.findMany({
    where: { is_active },
    select: {
      id: true,
      full_name: true,
      member_code: true,
      email: true,
      phone: true,
      gender: true,
      registration_date: true,
      created_by: true,
      is_active: true,
      staff: {
        select: {
          full_name: true,
        },
      },
    },
    orderBy: { created_at: "desc" },
  });
}

export async function updatedMember(memberId: string, staffId: string) {
  return prisma.members.update({
    where: { id: memberId },
    data: { created_by: staffId },
    include: { staff: true },
  });
}
