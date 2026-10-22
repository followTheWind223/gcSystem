<script setup>
defineProps({ name: { type: String, default: 'spark' }, size: { type: [Number, String], default: 20 } })
const paths = {
  spark: 'm12 3 2.4 6.6L21 12l-6.6 2.4L12 21l-2.4-6.6L3 12l6.6-2.4L12 3Z',
  bolt: 'm13 2-9 12h7l-1 8 10-13h-8l1-7Z',
  search: 'm21 21-5-5 M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0',
  cart: 'M2 3h3l3 12h10l3-9H6 M9 20h.01 M18 20h.01',
  arrow: 'M4 12h16m-6-6 6 6-6 6',
  chevron: 'm9 5 7 7-7 7',
  down: 'm6 9 6 6 6-6',
  grid: 'M3 3h7v7H3V3Zm11 0h7v7h-7V3ZM3 14h7v7H3v-7Zm11 0h7v7h-7v-7Z',
  game: 'M6 6h12c3 0 5 13 2 13-2 0-4-4-5-4H9c-1 0-3 4-5 4-3 0-1-13 2-13Zm0 4v4m-2-2h4m8-1h.01m3 3h.01',
  shield: 'm12 3 8 3v6c0 5-8 9-8 9S4 17 4 12V6l8-3Zm-4 9 3 3 5-6',
  clock: 'M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0ZM12 6v6l4 2',
  user: 'M16 7a4 4 0 1 1-8 0 4 4 0 0 1 8 0ZM4 21v-2a8 8 0 0 1 16 0v2',
  box: 'm3 7 9-5 9 5v10l-9 5-9-5V7Zm0 0 9 5 9-5M12 12v10M7.5 4.5l9 5',
  star: 'm12 2 3 6.5 7 1-5 5 1.2 7-6.2-3.3L5.8 21l1.2-6.5-5-5 7-1L12 2Z',
  close: 'm6 6 12 12M6 18 18 6',
  check: 'm5 12 4 4L19 6',
  plus: 'M12 5v14M5 12h14',
  minus: 'M5 12h14',
  trash: 'M3 6h18M9 6V3h6v3M5 6l1 15h12l1-15M10 10v7m4-7v7',
  refresh: 'M20 7a9 9 0 1 0 1 9M20 2v6h-6',
  lock: 'M6 10h12v11H6V10Zm2 0V6a4 4 0 0 1 8 0v4m-4 4v3',
  eye: 'M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12Zm13 0a3 3 0 1 1-6 0 3 3 0 0 1 6 0',
  mail: 'M3 5h18v14H3V5Zm0 1 9 7 9-7',
  logout: 'M9 3H3v18h6M10 12h11m-5-5 5 5-5 5',
  tune: 'M4 5h16M4 12h16M4 19h16M8 2v6m8 1v6m-6 1v6',
  info: 'M22 12a10 10 0 1 1-20 0 10 10 0 0 1 20 0ZM12 11v6m0-10h.01',
  flame: 'M13 2c2 6-4 6-2 11 2-1 3-3 3-5 6 5 7 12 0 14-9 3-14-5-9-11 0 3 2 4 3 4-1-5 4-7 5-13Z',
  headset: 'M3 14v-3a9 9 0 0 1 18 0v3M3 12h4v8H3v-8Zm14 0h4v8h-4v-8ZM17 20c0 2-3 2-5 2',
}
</script>
<template><svg :width="size" :height="size" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.65" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path :d="paths[name] || paths.spark" /></svg></template>
