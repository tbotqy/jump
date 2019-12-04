export default function formatDateString(dateString: string): string {
  const date = new Date(dateString);
  return `${date.toLocaleDateString()} - ${date.toLocaleTimeString()}`;
}
