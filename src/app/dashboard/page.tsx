"use client";

import { ChartAreaInteractive } from "@/components/dashboard/chart-area-interactive";
import { DataTable } from "@/components/dashboard/data-table";
import { SectionCards } from "@/components/dashboard/section-cards";
import { useEffect, useState } from "react";
import { MemberDTO } from "../types/member";
import { StaffDTO } from "../types/staff";

export default function Page() {
  const [members, setMembers] = useState<MemberDTO[]>([]);
  const [staffList, setStaffList] = useState<StaffDTO[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchMembers() {
      try {
        const [memberRes, staffRes] = await Promise.all([
          fetch("/api/members"),
          fetch("/api/staff"),
        ]);
        const membersData = await memberRes.json();
        const staffData = await staffRes.json();

        setMembers(membersData);
        setStaffList(staffData);
      } catch (err) {
        console.error("Error fetching members:", err);
      } finally {
        setLoading(false);
      }
    }
    fetchMembers();
  }, []);

  if (loading) return <p>Loading...</p>;

  return (
    <div className="flex flex-1 flex-col">
      <div className="@container/main flex flex-1 flex-col gap-2">
        <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
          <SectionCards />
          <div className="px-4 lg:px-6">
            <ChartAreaInteractive />
          </div>
          <DataTable data={members} staffList={staffList} />
        </div>
      </div>
    </div>
  );
}
