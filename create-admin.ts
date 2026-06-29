import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const email = 'admin@momplan.com';
  const password = 'adminPassword123!';

  const existingAdmin = await prisma.user.findUnique({ where: { email } });

  if (existingAdmin) {
    console.log('✅ Admin already exists:');
    console.log(`Email: ${email}`);
    console.log(`Password: ${password}`);
    return;
  }

  const password_hash = await bcrypt.hash(password, 10);

  await prisma.user.create({
    data: {
      email,
      password_hash,
      first_name: 'System',
      last_name: 'Admin',
      role: 'admin',
    },
  });

  console.log('🚀 Admin account created successfully!');
  console.log(`Email: ${email}`);
  console.log(`Password: ${password}`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
