import { NextResponse } from "next/server";
import { getActiveMembers } from "@/lib/data/member";

export async function GET() {
  try {
    const members = await getActiveMembers(true);

    return NextResponse.json(members);
  } catch {
    return NextResponse.json(
      { error: "Failed to fetch members" },
      { status: 400 }
    );
  }
}
