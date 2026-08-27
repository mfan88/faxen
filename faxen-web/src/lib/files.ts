export const fileTypes = {
  image: [
    { label: "JPEG (.jpg)", ext: "jpg", mime: "image/jpeg" },
    { label: "JPEG (.jpeg)", ext: "jpeg", mime: "image/jpeg" },
    { label: "PNG (.png)", ext: "png", mime: "image/png" },
    { label: "SVG (.svg)", ext: "svg", mime: "image/svg+xml" },
    { label: "TIFF (.tif)", ext: "tif", mime: "image/tiff" },
    { label: "OGG (.ogg)", ext: "ogg", mime: "image/ogg" }
  ],
  video: [
    { label: "MP4 (.mp4)", ext: "mp4", mime: "video/mp4" },
    { label: "M4A (.m4a)", ext: "m4a", mime: "video/x-m4a" },
    { label: "MOV (.mov)", ext: "mov", mime: "video/quicktime" },
    { label: "MPEG (.mpeg)", ext: "mpeg", mime: "video/mpeg" },
    { label: "OGG (.ogg)", ext: "ogg", mime: "video/ogg" }
  ]
} as const;

export type FileCategory = keyof typeof fileTypes;

export type AcceptedFileTypes = {
  [K in FileCategory]: string[];
};

export function getDefaultFileTypes(): AcceptedFileTypes {
  const enabledSet = {} as AcceptedFileTypes;
  for (const category of Object.keys(fileTypes) as FileCategory[]) {
    enabledSet[category] = fileTypes[category].map((type) => type.ext);
  }
  return enabledSet;
}

export function buildAccepts(selected: Partial<AcceptedFileTypes>) {
  const accept: Record<string, string[]> = {};
  for (const category of Object.keys(fileTypes) as FileCategory[]) {
    const exts = selected[category];
    if (!exts?.length) continue;
    for (const { ext, mime } of fileTypes[category]) {
      if (!exts.includes(ext)) continue;
      if (!accept[mime]) accept[mime] = [];
      if (!accept[mime].includes("." + ext)) {
        accept[mime].push("." + ext);
      }
    }
  }
  return accept;
}

export function buildAcceptGroups(selected: Partial<AcceptedFileTypes>) {
  return (Object.keys(fileTypes) as FileCategory[]).flatMap((category) => {
    const accept = buildAccepts({ [category]: selected[category] ?? [] });
    if (Object.keys(accept).length === 0) return [];
    return [{ description: category, accept }];
  });
}