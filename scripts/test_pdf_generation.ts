import { PrismaClient } from '@prisma/client';
import { PdfService } from '../src/modules/pdf/pdf.service';

const prisma = new PrismaClient();
const pdfService = new PdfService();

async function run() {
  // Find a user with a family profile
  const user = await prisma.user.findFirst({
    where: { family_profile: { isNot: null } },
    include: { family_profile: true },
  });

  if (!user) {
    console.log('No user with a family profile found.');
    return;
  }

  console.log(`Using user: ${user.email} (ID: ${user.id})`);

  // Find a standard program (e.g., SNAP)
  const standardProgram = await prisma.benefitProgram.findFirst({
    where: { name: { contains: 'SNAP', mode: 'insensitive' } },
  });

  if (standardProgram) {
    console.log(`Testing standard PDF generation for program: ${standardProgram.name}`);
    try {
      const res = await pdfService.generatePdfBuffer(user.id, standardProgram.id);
      console.log(`✅ Standard PDF generated successfully. UUID: ${res.uuid}`);
    } catch (err) {
      console.error(`❌ Standard PDF generation failed:`, err);
    }
  } else {
    console.log('No SNAP program found for testing standard generation.');
  }

  // Create a dummy program to represent 'Additional Review'
  const dummyProgram = await prisma.benefitProgram.create({
    data: {
      name: 'Additional Review Test Program',
      agency: 'Test Agency',
      program_type: 'Test',
      is_active: false,
    },
  });

  console.log(`Testing unmapped/Additional Review PDF generation for program: ${dummyProgram.name}`);
  try {
    const res = await pdfService.generatePdfBuffer(user.id, dummyProgram.id);
    console.log(`✅ Additional Review PDF generated successfully without crashing. UUID: ${res.uuid}`);
  } catch (err) {
    console.error(`❌ Additional Review PDF generation failed:`, err);
  } finally {
    // Cleanup
    await prisma.benefitProgram.delete({ where: { id: dummyProgram.id } });
    console.log('Cleaned up dummy program.');
  }
}

run()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
