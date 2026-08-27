import { getTokenData } from "@/lib/links";
import { getDefaultFileTypes } from "@/lib/files";
import FileUploadBox from "@/components/dropzone";

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
    <div className="flex flex-col items-center justify-center h-screen w-screen px-6">
      <h1 className="text-2xl font-serif text-center">faxen file upload</h1>
      <div className="mt-6 w-full max-w-md">
        <FileUploadBox
          acceptedFileTypes={data.acceptedFileTypes ?? getDefaultFileTypes()}
        />
      </div>
    </div>
  );
}
