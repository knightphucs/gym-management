import { NextResponse } from "next/server";
import { assignStaffToMember } from "@/lib/actions/member";

export async function PUT(
  req: Request,
  context: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await context.params;
    const body = await req.json();
    const { staffId } = body;

    const updatedMember = await assignStaffToMember(id, staffId);
    return NextResponse.json(updatedMember, { status: 200 });
  } catch {
    return NextResponse.json(
      { error: "Failed to update staff" },
      { status: 400 }
    );
  }
}
