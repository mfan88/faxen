import { auth } from "@clerk/nextjs/server";
import { redirect } from "next/navigation";
import { SignUpForm } from "@/components/clerk-auth-forms";

export default async function SignUpPage() {
  const { userId } = await auth();
  if (userId) {
    redirect("/dashboard");
  }

  return <SignUpForm />;
}
