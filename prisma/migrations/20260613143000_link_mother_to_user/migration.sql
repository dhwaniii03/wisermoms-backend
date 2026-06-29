-- CreateIndex
CREATE UNIQUE INDEX "mothers_user_id_key" ON "mothers"("user_id");

-- AddForeignKey
ALTER TABLE "mothers" ADD CONSTRAINT "mothers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
