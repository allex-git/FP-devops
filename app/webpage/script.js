let lastPod = null;

const podMap = {};
let podCounter = 1;

let loading = false;

function getPodIndex(name) {
    const podName = name || "unknown";

    if (!podMap[podName]) {
        podMap[podName] = podCounter++;
    }

    return podMap[podName];
}

function formatDate(date) {
    if (!date) {
        return "N/A";
    }

    const d = new Date(date);

    if (Number.isNaN(d.getTime())) {
        return "Invalid date";
    }

    const pad = n => n.toString().padStart(2, "0");

    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

async function loadData() {
    if (loading) {
        return;
    }

    loading = true;

    try {
        const res = await fetch("/api");

        if (!res.ok) {
            throw new Error(`HTTP error: ${res.status}`);
        }

        const data = await res.json();

        const podName = data.pod_name || "unknown";
        const changed = lastPod && lastPod !== podName;

        lastPod = podName;

        render(data, changed);

    } catch (error) {
        console.error("Backend request failed:", error);

        document.getElementById("app").innerHTML = `
            <div class="panel error">
                <div class="status-card status-error">
                    Backend error
                </div>
            </div>
        `;
    } finally {
        loading = false;
    }
}

function render(data, changed) {
    const isOk = data.status === "ok";

    const podName = data.pod_name || "unknown";
    const podIp = data.pod_ip || "unknown";
    const author = data.author || "N/A";

    const podIndex = getPodIndex(podName);

    document.getElementById("app").innerHTML = `
        <div class="panel ${isOk ? "ok" : "error"} ${changed ? "switch" : ""}">

            <div class="badge">POD #${podIndex}</div>

            <div class="project-title">
                <span class="devops">DevOps 11</span>
                <span class="final">Final Project</span>
            </div>

            <div class="status-card ${isOk ? "status-ok" : "status-error"}">
                Status ${isOk ? "200 OK" : "503 ERROR"}
            </div>

            <div class="pod-info">

                <div class="row">
                    <span class="label">Pod Name</span>
                    <span>${podName}</span>
                </div>

                <div class="row">
                    <span class="label">Pod IP</span>
                    <span>${podIp}</span>
                </div>

                ${data.uptime_seconds !== undefined ? `
                <div class="row">
                    <span class="label">Uptime</span>
                    <span>${data.uptime_seconds}s</span>
                </div>` : ""}

                ${data.datetime ? `
                <div class="row">
                    <span class="label">Time</span>
                    <span>${formatDate(data.datetime)}</span>
                </div>` : ""}

                <div class="row">
                    <span class="label">Author</span>
                    <span>${author}</span>
                </div>

            </div>

        </div>
    `;
}

loadData();
setInterval(loadData, 2000);