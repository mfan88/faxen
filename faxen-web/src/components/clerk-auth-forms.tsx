"use client";

import { SignIn, SignUp } from "@clerk/nextjs";

export function SignInForm() {
  return <SignIn />;
}

export function SignUpForm() {
  return <SignUp />;
}
