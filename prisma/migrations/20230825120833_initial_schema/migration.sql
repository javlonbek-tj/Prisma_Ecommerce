-- CreateEnum
CREATE TYPE "RoleEnumType" AS ENUM ('USER', 'ADMIN');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "RoleEnumType" NOT NULL DEFAULT 'USER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "photo" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Cart" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Cart_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductsOnCarts" (
    "id" TEXT NOT NULL,
    "cartId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductsOnCarts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Product" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "top" BOOLEAN NOT NULL,
    "productTypeId" TEXT NOT NULL,
    "productBrandId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductInfo" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductInfo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductBrand" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductBrand_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductType" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TypeBrands" (
    "id" TEXT NOT NULL,
    "typeId" TEXT NOT NULL,
    "brandId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TypeBrands_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Image" (
    "id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Image_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Order" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductsOnOrders" (
    "id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "phone" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "province" TEXT NOT NULL,
    "region" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "orderId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductsOnOrders_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Cart_userId_key" ON "Cart"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Order_userId_key" ON "Order"("userId");

-- AddForeignKey
ALTER TABLE "Cart" ADD CONSTRAINT "Cart_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductsOnCarts" ADD CONSTRAINT "ProductsOnCarts_cartId_fkey" FOREIGN KEY ("cartId") REFERENCES "Cart"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductsOnCarts" ADD CONSTRAINT "ProductsOnCarts_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_productTypeId_fkey" FOREIGN KEY ("productTypeId") REFERENCES "ProductType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_productBrandId_fkey" FOREIGN KEY ("productBrandId") REFERENCES "ProductBrand"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductInfo" ADD CONSTRAINT "ProductInfo_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TypeBrands" ADD CONSTRAINT "TypeBrands_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES "ProductType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TypeBrands" ADD CONSTRAINT "TypeBrands_brandId_fkey" FOREIGN KEY ("brandId") REFERENCES "ProductBrand"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Image" ADD CONSTRAINT "Image_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductsOnOrders" ADD CONSTRAINT "ProductsOnOrders_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductsOnOrders" ADD CONSTRAINT "ProductsOnOrders_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "Order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
