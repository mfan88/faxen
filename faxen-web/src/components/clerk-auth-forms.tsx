"use client";

import { SignIn, SignUp } from "@clerk/nextjs";

export function SignInForm() {
  return (
    <div className="w-full min-w-0 max-w-full overflow-x-auto">
      <SignIn />
    </div>
  );
}

export function SignUpForm() {
  return (
    <div className="w-full min-w-0 max-w-full overflow-x-auto">
      <SignUp />
    </div>
  );
}
