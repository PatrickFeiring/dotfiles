<script lang="ts" context="module">
	import |component$ from './|component$.svelte';

	export const meta = {
		component: |component$
	};
</script>

<script lang="ts">
	import { Story, Template } from '@storybook/addon-svelte-csf';
</script>

<Template let:args>
	<|component$ {...args} />
</Template>

<Story
	name="|default_story$"
	args={{
		|final_position$
	}}
/>

