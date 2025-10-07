export interface MemberDTO {
  id: string;
  member_code: string;
  full_name: string;
  email: string | null;
  phone: string;
  gender: string | null;
  avatar_url: string | null;
  registration_date: string;
  created_by: string;
  is_active: boolean;
  staff: { full_name: string } | null;
}
