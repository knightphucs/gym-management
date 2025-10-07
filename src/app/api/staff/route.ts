// src/app/api/staff/route.ts
import { NextResponse } from "next/server";
import { getStaffNames } from "@/lib/data/staff";

export async function GET() {
  try {
    const staff = await getStaffNames();

    return NextResponse.json(staff);
  } catch (err) {
    return NextResponse.json(
      { error: "Failed to fetch staff" },
      { status: 400 }
    );
  }
}
