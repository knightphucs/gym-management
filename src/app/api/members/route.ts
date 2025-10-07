import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { getActiveMembers } from "@/lib/data/member";

export async function GET() {
  try {
    const members = await getActiveMembers();

    return NextResponse.json(members);
  } catch (err) {
    return NextResponse.json(
      { error: "Failed to fetch members" },
      { status: 400 }
    );
  }
}
