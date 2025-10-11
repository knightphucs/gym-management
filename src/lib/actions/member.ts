import { updatedMember } from "../data/member";

export async function assignStaffToMember(memberId: string, staffId: string) {
  if (!staffId) {
    throw new Error("staffId is required");
  }

  try {
    const updated = await updatedMember(memberId, staffId);
    return updated;
  } catch {
    throw new Error("Failed to update staff");
  }
}
