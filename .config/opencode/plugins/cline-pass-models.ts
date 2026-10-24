import { Plugin } from "@opencode/plugin";

const PROVIDER_ID = "cline-pass";
const DISCOVERY_URL = "https://api.cline.bot/api/v1/ai/cline/recommended-models";

type DiscoveredModel = {
  id: string;
  name: string;
};

async function discoverClinePassModels(): Promise<DiscoveredModel[]> {
  try {
    const response = await fetch(DISCOVERY_URL, {
      headers: { "user-agent": "opencode" },
    });
    if (!response.ok) return [];
    const body = (await response.json()) as { clinePass?: DiscoveredModel[] };
    return body.clinePass ?? [];
  } catch {
    return [];
  }
}

function localID(modelID: string): string {
  return modelID.startsWith(`${PROVIDER_ID}/`)
    ? modelID.slice(PROVIDER_ID.length + 1)
    : modelID;
}

export default Plugin.define({
  id: "cline-pass-models",
  async setup(ctx) {
    const discovered = await discoverClinePassModels();
    if (discovered.length === 0) return;

    await ctx.provider.transform((editor) => {
      const record = editor.get(PROVIDER_ID);
      if (!record) return;

      const models = [...record.models.values()].map((model) => ({
        ...structuredClone(model),
        id: localID(model.id),
      }));
      if (models.length === 0) return;

      const known = new Set(models.map((model) => model.modelID));
      for (const model of discovered) {
        if (known.has(model.id)) continue;
        const template =
          models.find((candidate) =>
            model.id.startsWith(`${candidate.modelID}-`),
          ) ?? models[0];
        models.push({
          ...structuredClone(template),
          id: localID(model.id),
          modelID: model.id,
          name: model.name,
        });
        known.add(model.id);
      }

      editor.models.set(PROVIDER_ID, models);
    });

    await ctx.provider.reload();
  },
});
