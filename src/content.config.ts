import { defineCollection, z } from 'astro:content';
import { glob, file } from 'astro/loaders';

const blog = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/blog' }),
  schema: z.object({
    title: z.string(),
    date: z.coerce.date(),
    description: z.string(),
    tags: z.array(z.string()).default([]),
    draft: z.boolean().default(false),
  }),
});

const cv = defineCollection({
  loader: file('src/content/cv/cv.yaml'),
  schema: z.object({
    name: z.string(),
    title: z.string(),
    summary: z.string().optional(),
    experience: z
      .array(
        z.object({
          company: z.string(),
          role: z.string(),
          start: z.string(),
          end: z.string().optional(),
          highlights: z.array(z.string()).default([]),
        })
      )
      .default([]),
    education: z
      .array(
        z.object({
          institution: z.string(),
          degree: z.string(),
          year: z.string(),
        })
      )
      .default([]),
    skills: z.array(z.string()).default([]),
    languages: z
      .array(
        z.object({
          language: z.string(),
          level: z.string(),
        })
      )
      .default([]),
  }),
});

const projects = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/projects' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    stack: z.array(z.string()).default([]),
    repo: z.string().url().optional(),
    live: z.string().url().optional(),
    status: z.enum(['active', 'archived', 'wip']).default('active'),
  }),
});

export const collections = { blog, cv, projects };
