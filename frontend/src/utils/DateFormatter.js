export default function formatDateString(dateString) {
  const date = new Date(dateString);
  return `${date.toLocaleDateString()} - ${date.toLocaleTimeString()}`;
}
