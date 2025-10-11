-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "auth";

-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "auth"."aal_level" AS ENUM ('aal1', 'aal2', 'aal3');

-- CreateEnum
CREATE TYPE "auth"."code_challenge_method" AS ENUM ('s256', 'plain');

-- CreateEnum
CREATE TYPE "auth"."factor_status" AS ENUM ('unverified', 'verified');

-- CreateEnum
CREATE TYPE "auth"."factor_type" AS ENUM ('totp', 'webauthn', 'phone');

-- CreateEnum
CREATE TYPE "auth"."oauth_registration_type" AS ENUM ('dynamic', 'manual');

-- CreateEnum
CREATE TYPE "auth"."one_time_token_type" AS ENUM ('confirmation_token', 'reauthentication_token', 'recovery_token', 'email_change_token_new', 'email_change_token_current', 'phone_change_token');

-- CreateTable
CREATE TABLE "public"."activity_logs" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "user_id" UUID,
    "action" VARCHAR(100) NOT NULL,
    "table_name" VARCHAR(50),
    "record_id" UUID,
    "old_data" JSONB,
    "new_data" JSONB,
    "ip_address" INET,
    "user_agent" TEXT,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "activity_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."backup_configs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "backup_name" VARCHAR(100) NOT NULL,
    "backup_type" VARCHAR(20) NOT NULL,
    "frequency" VARCHAR(20) NOT NULL,
    "schedule_time" TIME(6) NOT NULL,
    "retention_days" INTEGER NOT NULL,
    "backup_location" VARCHAR(255) NOT NULL,
    "tables_to_backup" JSONB NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "backup_configs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."data_retention_policies" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "policy_name" VARCHAR(100) NOT NULL,
    "table_name" VARCHAR(100) NOT NULL,
    "retention_period_days" INTEGER NOT NULL,
    "archive_before_delete" BOOLEAN DEFAULT false,
    "archive_location" VARCHAR(255),
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "data_retention_policies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."debt_payments" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "debt_id" UUID,
    "payment_amount" DECIMAL(12,0) NOT NULL,
    "payment_method_id" UUID,
    "payment_date" DATE DEFAULT CURRENT_DATE,
    "notes" TEXT,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "debt_payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."debts" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "debt_code" VARCHAR(20) NOT NULL,
    "debtor_type" VARCHAR(20) NOT NULL,
    "debtor_id" UUID,
    "debtor_name" VARCHAR(100) NOT NULL,
    "debt_type" VARCHAR(20) NOT NULL,
    "original_amount" DECIMAL(12,0) NOT NULL,
    "paid_amount" DECIMAL(12,0) DEFAULT 0,
    "remaining_amount" DECIMAL(12,0) NOT NULL,
    "due_date" DATE,
    "status" VARCHAR(20) DEFAULT 'pending',
    "description" TEXT,
    "reference_id" UUID,
    "reference_type" VARCHAR(50),
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "debts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."financial_transactions" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "transaction_code" VARCHAR(20) NOT NULL,
    "transaction_type" VARCHAR(20) NOT NULL,
    "category" VARCHAR(50) NOT NULL,
    "description" TEXT NOT NULL,
    "amount" DECIMAL(12,0) NOT NULL,
    "payment_method_id" UUID,
    "reference_id" UUID,
    "reference_type" VARCHAR(50),
    "transaction_date" DATE DEFAULT CURRENT_DATE,
    "receipt_url" TEXT,
    "notes" TEXT,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "financial_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."gym_schedules" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "schedule_type" VARCHAR(50) NOT NULL,
    "title" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "start_time" TIME(6),
    "end_time" TIME(6),
    "is_recurring" BOOLEAN DEFAULT false,
    "recurring_pattern" VARCHAR(20),
    "recurring_days" JSONB,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "gym_schedules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."installment_payments" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "plan_id" UUID,
    "installment_number" INTEGER NOT NULL,
    "due_date" DATE NOT NULL,
    "amount_due" DECIMAL(12,2) NOT NULL,
    "amount_paid" DECIMAL(12,2) DEFAULT 0,
    "payment_date" DATE,
    "status" VARCHAR(20) DEFAULT 'pending',
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "installment_payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."installment_plans" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "payment_id" UUID,
    "plan_type" VARCHAR(20) DEFAULT 'monthly',
    "total_installments" INTEGER NOT NULL,
    "interest_rate" DECIMAL(5,2) DEFAULT 0,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "status" VARCHAR(20) DEFAULT 'active',
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "installment_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."inventory_import_details" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "import_id" UUID,
    "product_id" UUID,
    "quantity" INTEGER NOT NULL,
    "unit_price" DECIMAL(12,0) NOT NULL,
    "total_price" DECIMAL(12,0) NOT NULL,
    "expiry_date" DATE,

    CONSTRAINT "inventory_import_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."inventory_imports" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "import_code" VARCHAR(20) NOT NULL,
    "supplier_name" VARCHAR(100),
    "supplier_contact" TEXT,
    "total_amount" DECIMAL(12,0) DEFAULT 0,
    "import_date" DATE DEFAULT CURRENT_DATE,
    "notes" TEXT,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "inventory_imports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."member_checkins" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "member_id" UUID,
    "membership_id" UUID,
    "check_in_time" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "check_out_time" TIMESTAMPTZ(6),
    "check_in_method" VARCHAR(20) DEFAULT 'manual',
    "created_by" UUID,

    CONSTRAINT "member_checkins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."members" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "member_code" VARCHAR(20) NOT NULL,
    "full_name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(255),
    "phone" VARCHAR(15) NOT NULL,
    "date_of_birth" DATE,
    "gender" VARCHAR(10),
    "address" TEXT,
    "emergency_contact_name" VARCHAR(100),
    "emergency_contact_phone" VARCHAR(15),
    "health_notes" TEXT,
    "avatar_url" TEXT,
    "face_id_data" JSONB,
    "registration_date" DATE DEFAULT CURRENT_DATE,
    "is_active" BOOLEAN DEFAULT true,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."memberships" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "membership_code" VARCHAR(20) NOT NULL,
    "member_id" UUID,
    "package_id" UUID,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "total_amount" DECIMAL(12,0) NOT NULL,
    "paid_amount" DECIMAL(12,0) DEFAULT 0,
    "remaining_amount" DECIMAL(12,0) DEFAULT 0,
    "status" VARCHAR(20) DEFAULT 'active',
    "freeze_start_date" DATE,
    "freeze_end_date" DATE,
    "freeze_reason" TEXT,
    "notes" TEXT,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "memberships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."notification_configs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "config_name" VARCHAR(100) NOT NULL,
    "trigger_type" VARCHAR(50) NOT NULL,
    "template_id" UUID,
    "trigger_days" INTEGER,
    "target_audience" VARCHAR(50),
    "send_time" TIME(6),
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notification_configs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."notification_templates" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "template_code" VARCHAR(50) NOT NULL,
    "template_name" VARCHAR(100) NOT NULL,
    "template_type" VARCHAR(20) NOT NULL,
    "subject" VARCHAR(200),
    "content" TEXT NOT NULL,
    "variables" JSONB NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notification_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."payment_details" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "payment_id" UUID,
    "method_id" UUID,
    "amount" DECIMAL(12,2) NOT NULL,
    "transaction_code" VARCHAR(50),
    "bank_name" VARCHAR(100),
    "account_number" VARCHAR(50),
    "receipt_url" TEXT,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."payment_methods" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "method_name" VARCHAR(50) NOT NULL,
    "method_code" VARCHAR(20) NOT NULL,
    "description" TEXT,
    "is_active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_methods_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."payments" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "payment_code" VARCHAR(20) NOT NULL,
    "member_id" UUID,
    "promotion_id" UUID,
    "total_amount" DECIMAL(12,2) NOT NULL,
    "discount_amount" DECIMAL(12,2) DEFAULT 0,
    "final_amount" DECIMAL(12,2) NOT NULL,
    "status" VARCHAR(20) DEFAULT 'pending',
    "reference_id" UUID,
    "reference_type" VARCHAR(50),
    "notes" TEXT,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."product_categories" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "category_name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "is_active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "product_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."products" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "product_code" VARCHAR(20) NOT NULL,
    "product_name" VARCHAR(100) NOT NULL,
    "category_id" UUID,
    "description" TEXT,
    "unit" VARCHAR(20) DEFAULT 'pcs',
    "purchase_price" DECIMAL(12,0),
    "selling_price" DECIMAL(12,0) NOT NULL,
    "current_stock" INTEGER DEFAULT 0,
    "min_stock_alert" INTEGER DEFAULT 5,
    "image_url" TEXT,
    "is_active" BOOLEAN DEFAULT true,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."promotions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "promotion_code" VARCHAR(50) NOT NULL,
    "promotion_name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "promotion_type" VARCHAR(50) NOT NULL,
    "discount_value" DECIMAL(10,2) NOT NULL,
    "min_purchase_amount" DECIMAL(12,2),
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "applicable_to" VARCHAR(50) NOT NULL,
    "usage_limit" INTEGER,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "promotions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."pt_clients" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "member_id" UUID,
    "trainer_id" UUID,
    "start_date" DATE DEFAULT CURRENT_DATE,
    "end_date" DATE,
    "sessions_total" INTEGER NOT NULL,
    "sessions_completed" INTEGER DEFAULT 0,
    "sessions_remaining" INTEGER,
    "hourly_rate" DECIMAL(12,0) NOT NULL,
    "total_amount" DECIMAL(12,0) NOT NULL,
    "paid_amount" DECIMAL(12,0) DEFAULT 0,
    "status" VARCHAR(20) DEFAULT 'active',
    "notes" TEXT,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pt_clients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."pt_schedules" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "pt_client_id" UUID,
    "trainer_id" UUID,
    "member_id" UUID,
    "scheduled_date" DATE NOT NULL,
    "start_time" TIME(6) NOT NULL,
    "end_time" TIME(6) NOT NULL,
    "status" VARCHAR(20) DEFAULT 'scheduled',
    "notes" TEXT,
    "completion_notes" TEXT,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pt_schedules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."sales_transaction_details" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "transaction_id" UUID,
    "product_id" UUID,
    "package_id" UUID,
    "quantity" INTEGER DEFAULT 1,
    "unit_price" DECIMAL(12,0) NOT NULL,
    "total_price" DECIMAL(12,0) NOT NULL,

    CONSTRAINT "sales_transaction_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."sales_transactions" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "transaction_code" VARCHAR(20) NOT NULL,
    "member_id" UUID,
    "promotion_id" UUID,
    "total_amount" DECIMAL(12,0) NOT NULL,
    "paid_amount" DECIMAL(12,0) NOT NULL,
    "change_amount" DECIMAL(12,0) DEFAULT 0,
    "transaction_type" VARCHAR(20) DEFAULT 'sale',
    "notes" TEXT,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sales_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."staff" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "auth_user_id" UUID,
    "staff_code" VARCHAR(20) NOT NULL,
    "full_name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(255),
    "phone" VARCHAR(15),
    "address" TEXT,
    "position" VARCHAR(50) NOT NULL,
    "salary" DECIMAL(12,0),
    "hire_date" DATE DEFAULT CURRENT_DATE,
    "is_active" BOOLEAN DEFAULT true,
    "avatar_url" TEXT,
    "permissions" JSONB DEFAULT '{}',
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "staff_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."workout_packages" (
    "id" UUID NOT NULL DEFAULT extensions.uuid_generate_v4(),
    "package_code" VARCHAR(20) NOT NULL,
    "package_name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "duration_days" INTEGER NOT NULL,
    "price" DECIMAL(12,0) NOT NULL,
    "discount_price" DECIMAL(12,0),
    "package_type" VARCHAR(50) DEFAULT 'standard',
    "features" JSONB,
    "max_freeze_days" INTEGER DEFAULT 0,
    "is_active" BOOLEAN DEFAULT true,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workout_packages_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "idx_backup_configs_frequency" ON "public"."backup_configs"("frequency");

-- CreateIndex
CREATE INDEX "idx_backup_configs_type" ON "public"."backup_configs"("backup_type");

-- CreateIndex
CREATE INDEX "idx_data_retention_table" ON "public"."data_retention_policies"("table_name");

-- CreateIndex
CREATE UNIQUE INDEX "debts_debt_code_key" ON "public"."debts"("debt_code");

-- CreateIndex
CREATE INDEX "idx_debts_due_date" ON "public"."debts"("due_date");

-- CreateIndex
CREATE INDEX "idx_debts_status" ON "public"."debts"("status");

-- CreateIndex
CREATE UNIQUE INDEX "financial_transactions_transaction_code_key" ON "public"."financial_transactions"("transaction_code");

-- CreateIndex
CREATE INDEX "idx_financial_transactions_date" ON "public"."financial_transactions"("transaction_date");

-- CreateIndex
CREATE INDEX "idx_financial_transactions_date_type" ON "public"."financial_transactions"("transaction_date", "transaction_type");

-- CreateIndex
CREATE INDEX "idx_financial_transactions_type" ON "public"."financial_transactions"("transaction_type");

-- CreateIndex
CREATE INDEX "idx_gym_schedules_date" ON "public"."gym_schedules"("start_date", "end_date");

-- CreateIndex
CREATE INDEX "idx_gym_schedules_type" ON "public"."gym_schedules"("schedule_type");

-- CreateIndex
CREATE INDEX "idx_installment_payments_plan_id" ON "public"."installment_payments"("plan_id");

-- CreateIndex
CREATE INDEX "idx_installment_plans_payment_id" ON "public"."installment_plans"("payment_id");

-- CreateIndex
CREATE UNIQUE INDEX "inventory_imports_import_code_key" ON "public"."inventory_imports"("import_code");

-- CreateIndex
CREATE INDEX "idx_member_checkins_member_date" ON "public"."member_checkins"("member_id", "check_in_time");

-- CreateIndex
CREATE INDEX "idx_member_checkins_member_time" ON "public"."member_checkins"("member_id", "check_in_time");

-- CreateIndex
CREATE UNIQUE INDEX "members_member_code_key" ON "public"."members"("member_code");

-- CreateIndex
CREATE INDEX "idx_members_member_code" ON "public"."members"("member_code");

-- CreateIndex
CREATE INDEX "idx_members_phone" ON "public"."members"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "memberships_membership_code_key" ON "public"."memberships"("membership_code");

-- CreateIndex
CREATE INDEX "idx_memberships_dates" ON "public"."memberships"("start_date", "end_date");

-- CreateIndex
CREATE INDEX "idx_memberships_member_id" ON "public"."memberships"("member_id");

-- CreateIndex
CREATE INDEX "idx_memberships_status" ON "public"."memberships"("status");

-- CreateIndex
CREATE INDEX "idx_notification_configs_template_id" ON "public"."notification_configs"("template_id");

-- CreateIndex
CREATE INDEX "idx_notification_configs_trigger_type" ON "public"."notification_configs"("trigger_type");

-- CreateIndex
CREATE UNIQUE INDEX "notification_templates_template_code_key" ON "public"."notification_templates"("template_code");

-- CreateIndex
CREATE INDEX "idx_notification_templates_code" ON "public"."notification_templates"("template_code");

-- CreateIndex
CREATE INDEX "idx_notification_templates_type" ON "public"."notification_templates"("template_type");

-- CreateIndex
CREATE INDEX "idx_payment_details_payment_id" ON "public"."payment_details"("payment_id");

-- CreateIndex
CREATE UNIQUE INDEX "payment_methods_method_code_key" ON "public"."payment_methods"("method_code");

-- CreateIndex
CREATE UNIQUE INDEX "payments_payment_code_key" ON "public"."payments"("payment_code");

-- CreateIndex
CREATE INDEX "idx_payments_member_id" ON "public"."payments"("member_id");

-- CreateIndex
CREATE INDEX "idx_payments_status" ON "public"."payments"("status");

-- CreateIndex
CREATE UNIQUE INDEX "products_product_code_key" ON "public"."products"("product_code");

-- CreateIndex
CREATE UNIQUE INDEX "promotions_promotion_code_key" ON "public"."promotions"("promotion_code");

-- CreateIndex
CREATE INDEX "idx_promotions_applicable_to" ON "public"."promotions"("applicable_to");

-- CreateIndex
CREATE INDEX "idx_promotions_code" ON "public"."promotions"("promotion_code");

-- CreateIndex
CREATE INDEX "idx_promotions_date" ON "public"."promotions"("start_date", "end_date");

-- CreateIndex
CREATE INDEX "idx_promotions_type" ON "public"."promotions"("promotion_type");

-- CreateIndex
CREATE INDEX "idx_pt_schedules_date" ON "public"."pt_schedules"("scheduled_date");

-- CreateIndex
CREATE INDEX "idx_pt_schedules_date_trainer" ON "public"."pt_schedules"("scheduled_date", "trainer_id");

-- CreateIndex
CREATE UNIQUE INDEX "sales_transactions_transaction_code_key" ON "public"."sales_transactions"("transaction_code");

-- CreateIndex
CREATE INDEX "idx_sales_transactions_date" ON "public"."sales_transactions"("created_at");

-- CreateIndex
CREATE UNIQUE INDEX "staff_staff_code_key" ON "public"."staff"("staff_code");

-- CreateIndex
CREATE UNIQUE INDEX "staff_email_key" ON "public"."staff"("email");

-- CreateIndex
CREATE UNIQUE INDEX "workout_packages_package_code_key" ON "public"."workout_packages"("package_code");

-- AddForeignKey
ALTER TABLE "public"."activity_logs" ADD CONSTRAINT "activity_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."debt_payments" ADD CONSTRAINT "debt_payments_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."debt_payments" ADD CONSTRAINT "debt_payments_debt_id_fkey" FOREIGN KEY ("debt_id") REFERENCES "public"."debts"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."debt_payments" ADD CONSTRAINT "debt_payments_payment_method_id_fkey" FOREIGN KEY ("payment_method_id") REFERENCES "public"."payment_methods"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."debts" ADD CONSTRAINT "debts_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."financial_transactions" ADD CONSTRAINT "financial_transactions_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."financial_transactions" ADD CONSTRAINT "financial_transactions_payment_method_id_fkey" FOREIGN KEY ("payment_method_id") REFERENCES "public"."payment_methods"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."installment_payments" ADD CONSTRAINT "installment_payments_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "public"."installment_plans"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."installment_plans" ADD CONSTRAINT "installment_plans_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."inventory_import_details" ADD CONSTRAINT "inventory_import_details_import_id_fkey" FOREIGN KEY ("import_id") REFERENCES "public"."inventory_imports"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."inventory_import_details" ADD CONSTRAINT "inventory_import_details_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."inventory_imports" ADD CONSTRAINT "inventory_imports_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."member_checkins" ADD CONSTRAINT "member_checkins_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."member_checkins" ADD CONSTRAINT "member_checkins_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."members"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."member_checkins" ADD CONSTRAINT "member_checkins_membership_id_fkey" FOREIGN KEY ("membership_id") REFERENCES "public"."memberships"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."members" ADD CONSTRAINT "members_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."memberships" ADD CONSTRAINT "memberships_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."memberships" ADD CONSTRAINT "memberships_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."members"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."memberships" ADD CONSTRAINT "memberships_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "public"."workout_packages"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."notification_configs" ADD CONSTRAINT "notification_configs_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "public"."notification_templates"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."payment_details" ADD CONSTRAINT "payment_details_method_id_fkey" FOREIGN KEY ("method_id") REFERENCES "public"."payment_methods"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."payment_details" ADD CONSTRAINT "payment_details_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."payments" ADD CONSTRAINT "payments_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."payments" ADD CONSTRAINT "payments_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."members"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."payments" ADD CONSTRAINT "payments_promotion_id_fkey" FOREIGN KEY ("promotion_id") REFERENCES "public"."promotions"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."products" ADD CONSTRAINT "products_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."product_categories"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."products" ADD CONSTRAINT "products_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."pt_clients" ADD CONSTRAINT "pt_clients_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."pt_clients" ADD CONSTRAINT "pt_clients_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."members"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."pt_clients" ADD CONSTRAINT "pt_clients_trainer_id_fkey" FOREIGN KEY ("trainer_id") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."pt_schedules" ADD CONSTRAINT "pt_schedules_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."pt_schedules" ADD CONSTRAINT "pt_schedules_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."members"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."pt_schedules" ADD CONSTRAINT "pt_schedules_pt_client_id_fkey" FOREIGN KEY ("pt_client_id") REFERENCES "public"."pt_clients"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."pt_schedules" ADD CONSTRAINT "pt_schedules_trainer_id_fkey" FOREIGN KEY ("trainer_id") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."sales_transaction_details" ADD CONSTRAINT "sales_transaction_details_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "public"."workout_packages"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."sales_transaction_details" ADD CONSTRAINT "sales_transaction_details_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."sales_transaction_details" ADD CONSTRAINT "sales_transaction_details_transaction_id_fkey" FOREIGN KEY ("transaction_id") REFERENCES "public"."sales_transactions"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."sales_transactions" ADD CONSTRAINT "sales_transactions_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."sales_transactions" ADD CONSTRAINT "sales_transactions_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."members"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."sales_transactions" ADD CONSTRAINT "sales_transactions_promotion_id_fkey" FOREIGN KEY ("promotion_id") REFERENCES "public"."promotions"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."workout_packages" ADD CONSTRAINT "workout_packages_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."staff"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

