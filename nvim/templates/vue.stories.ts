import type { Meta, StoryObj } from '@storybook/vue3';
import |component$ from './|component$.vue';

const meta = {
    component: |component$,
} satisfies Meta<typeof |component$>;

export default meta;
type Story = StoryObj<typeof meta>;

export const |default_story$ = {
    args: {
        |final_position$
    }
} satisfies Story;
