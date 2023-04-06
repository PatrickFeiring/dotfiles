import type { Meta, StoryObj } from '@storybook/|framework$';
import |component$ from './|component$.|extension$';

const meta = {
    component: |component$,
} satisfies Meta<typeof |component$>;

export default meta;
type Story = StoryObj<typeof meta>;

export const |default_story$ = {
    |final_position$
} satisfies Story;
