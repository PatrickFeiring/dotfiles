import type { Meta, StoryObj } from '@storybook/svelte';
import |component$ from './|component$.svelte';

const meta = {
    component: |component$,
} satisfies Meta<|component$>;

export default meta;
type Story = StoryObj<typeof meta>;

export const |default_story$ = {
    args: {
        |final_position$
    }
} satisfies Story;

