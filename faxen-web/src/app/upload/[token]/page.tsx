import { getTokenData } from "@/lib/links";
import { getDefaultFileTypes } from "@/lib/files";
import FileUploadBox from "@/components/dropzone";
import { SiteHeader } from "@/components/site-header";

export default async function UploadPage({
  params,
}: Readonly<{
  params: Promise<{ token: string }>;
}>) {
  const { token } = await params;
  const data = await getTokenData(token);
  if (!data) {
    return null;
  }

  return (
    <div className="flex min-h-dvh w-full flex-col overflow-x-hidden">
      <SiteHeader />
      <main className="mx-auto flex w-full max-w-lg flex-1 flex-col items-center justify-center px-4 py-8 sm:px-6">
        <h1 className="text-center font-serif text-xl sm:text-2xl">
          faxen file upload
        </h1>
        <div className="mt-6 w-full">
          <FileUploadBox
            acceptedFileTypes={data.acceptedFileTypes ?? getDefaultFileTypes()}
          />
        </div>
      </main>
    </div>
  );
}
