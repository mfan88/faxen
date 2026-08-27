"use client";

import { useDropzone } from "react-dropzone";
import { cn } from "@/lib/utils";
import {
  buildAcceptGroups,
  type AcceptedFileTypes,
  type FileCategory,
} from "@/lib/files";

export default function FileUploadBox({
  acceptedFileTypes,
  className,
  title = "upload files",
  ...props
}: {
  acceptedFileTypes: AcceptedFileTypes;
  title?: string;
} & React.HTMLAttributes<HTMLDivElement>) {
  const { acceptedFiles, getRootProps, getInputProps, isDragActive } =
    useDropzone({
      useFsAccessApi: true,
      accept: buildAcceptGroups(acceptedFileTypes),
    });

  const extensions = (Object.keys(acceptedFileTypes) as FileCategory[])
    .flatMap((category) =>
      acceptedFileTypes[category].map((ext) => `.${ext}`),
    )
    .join(", ");

  return (
    <article
      {...getRootProps({
        ...props,
        className: cn(
          className,
          "w-full min-w-0 rounded-2xl border border-border bg-card p-4 backdrop-blur-md outline-none transition-colors sm:p-5",
          "focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50",
          isDragActive && "border-foreground/40 bg-card",
        ),
      })}
    >
      <input {...getInputProps()} />
      <header>
        <h2 className="text-lg font-semibold tracking-tight">{title}</h2>
      </header>
      <div className="mt-4">
        <div
          className={cn(
            "rounded-xl border border-dashed border-border px-3 py-8 text-center sm:px-4 sm:py-10",
            isDragActive && "border-foreground/50",
          )}
        >
          <p className="text-sm text-foreground">
            {isDragActive
              ? "drop files here"
              : "drop files here, or click to browse"}
          </p>
          {extensions ? (
            <p className="mt-2 break-words text-xs text-muted-foreground">{extensions}</p>
          ) : null}
        </div>
        {acceptedFiles.length > 0 ? (
          <ul className="mt-4 flex flex-col gap-2 text-sm">
            {acceptedFiles.map((file) => (
              <li
                key={`${file.name}-${file.size}-${file.lastModified}`}
                className="truncate text-muted-foreground"
              >
                {file.name}
              </li>
            ))}
          </ul>
        ) : null}
      </div>
    </article>
  );
}
