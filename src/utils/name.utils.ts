export type UserNameParts = {
  first_name: string;
  middle_name?: string | null;
  last_name: string;
};

export const userNameSelect = {
  first_name: true,
  middle_name: true,
  last_name: true,
} as const;

export function joinFullName(
  firstName?: string | null,
  middleName?: string | null,
  lastName?: string | null,
): string {
  return [firstName, middleName, lastName].filter((part) => part?.trim()).join(' ');
}

export function formatUserName(user: Partial<UserNameParts> | null | undefined): string {
  if (!user) return '';
  return joinFullName(user.first_name, user.middle_name, user.last_name);
}

export function hasUserName(user: Partial<UserNameParts> | null | undefined): boolean {
  return Boolean(user?.first_name?.trim() && user?.last_name?.trim());
}

export function userInitials(user: Partial<UserNameParts> | null | undefined): string {
  const first = user?.first_name?.trim();
  const last = user?.last_name?.trim();
  if (first && last) return `${first[0]}${last[0]}`.toUpperCase();
  if (first) return first[0].toUpperCase();
  if (last) return last[0].toUpperCase();
  return '';
}

export function splitFullName(fullName: string): {
  first_name: string;
  middle_name: string | null;
  last_name: string;
} {
  const parts = fullName.trim().split(/\s+/).filter(Boolean);

  if (parts.length === 0) {
    return { first_name: '', middle_name: null, last_name: '' };
  }
  if (parts.length === 1) {
    return { first_name: parts[0], middle_name: null, last_name: '' };
  }
  if (parts.length === 2) {
    return { first_name: parts[0], middle_name: null, last_name: parts[1] };
  }

  return {
    first_name: parts[0],
    middle_name: parts.slice(1, -1).join(' '),
    last_name: parts[parts.length - 1],
  };
}
