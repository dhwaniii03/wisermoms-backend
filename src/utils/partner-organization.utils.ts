import { Organization } from '@prisma/client';

export type PartnerOrganization = {
  id: string;
  name: string;
  type: string | null;
  website: string | null;
  description: string | null;
  phone: string | null;
  address: string | null;
  city: string | null;
  state: string | null;
  zip: string | null;
  county: string | null;
  country: string | null;
  contact_email: string | null;
  employees: string | null;
  founded: string | null;
  tax_id: string | null;
  linkedin: string | null;
  tagline: string | null;
  services_offered: string | null;
  service_area: string | null;
  primary_language: string | null;
  notification_frequency: string | null;
  case_numbering_prefix: string | null;
  onboarding_completed: boolean;
  created_at: Date;
};

export function toPartnerOrganization(org: Organization): PartnerOrganization {
  return {
    id: org.id,
    name: org.org_name,
    type: org.category || org.org_type || null,
    website: org.website,
    description: org.description ?? org.purpose,
    phone: org.phone,
    address: org.address,
    city: org.city,
    state: org.state,
    zip: org.zip_code,
    county: org.county,
    country: org.country,
    contact_email: org.contact_email ?? org.email,
    employees: org.employees,
    founded: org.founded,
    tax_id: org.tax_id,
    linkedin: org.linkedin,
    tagline: org.tagline,
    services_offered: org.services_offered,
    service_area: org.service_area,
    primary_language: org.primary_language,
    notification_frequency: org.notification_frequency,
    case_numbering_prefix: org.case_numbering_prefix,
    onboarding_completed: org.onboarding_completed,
    created_at: org.created_at ?? new Date(),
  };
}
