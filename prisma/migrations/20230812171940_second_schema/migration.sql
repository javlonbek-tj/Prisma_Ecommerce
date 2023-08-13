/*
  Warnings:

  - You are about to drop the `_TypeBrands` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "_TypeBrands" DROP CONSTRAINT "_TypeBrands_A_fkey";

-- DropForeignKey
ALTER TABLE "_TypeBrands" DROP CONSTRAINT "_TypeBrands_B_fkey";

-- DropTable
DROP TABLE "_TypeBrands";

-- CreateTable
CREATE TABLE "TypeBrands" (
    "id" TEXT NOT NULL,
    "typeId" TEXT NOT NULL,
    "brandId" TEXT NOT NULL,

    CONSTRAINT "TypeBrands_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "TypeBrands" ADD CONSTRAINT "TypeBrands_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES "ProductType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TypeBrands" ADD CONSTRAINT "TypeBrands_brandId_fkey" FOREIGN KEY ("brandId") REFERENCES "ProductBrand"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
