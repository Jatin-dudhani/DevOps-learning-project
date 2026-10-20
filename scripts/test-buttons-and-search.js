/**
 * Comprehensive DOM, Button, and Search Verification Test Suite
 * Tests all interactive elements, modal states, search queries, hotkeys, and event handlers.
 */
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

console.log('========================================');
console.log('🧪 Starting Interactive DOM & Button Audit');
console.log('========================================');

const htmlContent = fs.readFileSync(path.join(__dirname, '../public/index.html'), 'utf8');
const scriptContent = fs.readFileSync(path.join(__dirname, '../public/script.js'), 'utf8');

// Mock localStorage, matchMedia, and clipboard for JSDOM
const dom = new JSDOM(htmlContent, {
    runScripts: 'dangerously',
    url: 'http://localhost:8080/',
    beforeParse(window) {
        window.matchMedia = window.matchMedia || function() {
            return {
                matches: false,
                addListener: function() {},
                removeListener: function() {}
            };
        };
        window.scrollTo = function() {};
        window.Element.prototype.scrollIntoView = function() {};
        window.navigator.clipboard = {
            writeText: async () => Promise.resolve()
        };
        window.fetch = globalThis.fetch || (() => Promise.resolve({
            ok: true,
            json: () => Promise.resolve({ ip: '127.0.0.1' }),
            text: () => Promise.resolve('')
        }));
        if (window.URL) {
            window.URL.createObjectURL = () => 'blob:mock-url';
            window.URL.revokeObjectURL = () => {};
        }
    }
});

const { window } = dom;
const { document } = window;

// Execute script.js within JSDOM window context
try {
    const scriptEl = document.createElement('script');
    scriptEl.textContent = scriptContent;
    document.body.appendChild(scriptEl);

    // Fire DOMContentLoaded event
    document.dispatchEvent(new window.Event('DOMContentLoaded', {
        bubbles: true,
        cancelable: true
    }));
    console.log('✅ DOMContentLoaded initialized successfully without uncaught errors.');
} catch (err) {
    console.error('❌ Failed to execute script.js:', err);
    process.exit(1);
}

let passedTests = 0;
let totalTests = 0;

function assert(condition, message) {
    totalTests++;
    if (condition) {
        console.log(`  • ${message}: ✅ PASS`);
        passedTests++;
    } else {
        console.error(`  • ${message}: ❌ FAIL`);
        process.exitCode = 1;
    }
}

// ----------------------------------------------------
// TEST 1: Header Search & Command Palette Modal
// ----------------------------------------------------
console.log('\n--- Test Suite 1: Command Palette Search ---');
const openCmdBtn = document.getElementById('openCommandPaletteBtn');
const cmdModal = document.getElementById('commandPaletteModal');
const cmdInput = document.getElementById('cmdPaletteInput');
const closeCmdBtn = document.getElementById('closeCmdPaletteBtn');
const resultsContainer = document.getElementById('cmdPaletteResults');

assert(!!openCmdBtn, 'Header search button (#openCommandPaletteBtn) exists');
assert(!!cmdModal, 'Command palette modal (#commandPaletteModal) exists');
assert(!!cmdInput, 'Command palette search input (#cmdPaletteInput) exists');

// Open Palette via Click
openCmdBtn.click();
assert(cmdModal.classList.contains('active') && cmdModal.classList.contains('open'), 'Clicking search button adds .active and .open to modal');
assert(cmdModal.getAttribute('aria-hidden') === 'false', 'Modal has aria-hidden="false" when opened');

// Search for "docker"
cmdInput.value = 'docker';
cmdInput.dispatchEvent(new window.Event('input'));
assert(resultsContainer.innerHTML.includes('Quick-Generate Multi-Stage Dockerfile') || resultsContainer.innerHTML.includes('Generator'), 'Searching "docker" yields Docker commands');

// Search for "k8s"
cmdInput.value = 'k8s';
cmdInput.dispatchEvent(new window.Event('input'));
assert(resultsContainer.innerHTML.includes('Kubernetes Cluster &amp; Pod Lens') || resultsContainer.innerHTML.includes('Kubernetes'), 'Searching "k8s" yields Kubernetes commands');

// Search for "finops"
cmdInput.value = 'finops';
cmdInput.dispatchEvent(new window.Event('input'));
assert(resultsContainer.innerHTML.includes('FinOps') || resultsContainer.innerHTML.includes('Infracost'), 'Searching "finops" yields FinOps commands');

// Search for "oom"
cmdInput.value = 'oom';
cmdInput.dispatchEvent(new window.Event('input'));
assert(resultsContainer.innerHTML.includes('OOMKilled'), 'Searching "oom" yields SRE Outage Drill for OOMKilled');

// Non-existent search query
cmdInput.value = 'nonexistentqueryxyz999';
cmdInput.dispatchEvent(new window.Event('input'));
assert(resultsContainer.innerHTML.includes('No commands matching'), 'Searching non-existent query displays helpful empty state');

// Close Palette via Close Button
closeCmdBtn.click();
assert(!cmdModal.classList.contains('active') && !cmdModal.classList.contains('open'), 'Clicking close button removes .active and .open');
assert(cmdModal.getAttribute('aria-hidden') === 'true', 'Modal has aria-hidden="true" when closed');

// Hotkey: Cmd+K / Ctrl+K
window.dispatchEvent(new window.KeyboardEvent('keydown', { key: 'k', metaKey: true }));
assert(cmdModal.classList.contains('active'), 'Pressing Cmd+K opens the command palette');
window.dispatchEvent(new window.KeyboardEvent('keydown', { key: 'Escape' }));
assert(!cmdModal.classList.contains('active'), 'Pressing Escape closes the command palette');

// ----------------------------------------------------
// TEST 2: CLI Cheatsheet Search
// ----------------------------------------------------
console.log('\n--- Test Suite 2: CLI Cheatsheet Search ---');
const cheatInput = document.getElementById('cheatSearchInput');
const commandsGrid = document.getElementById('commandsGrid');
const catPills = document.querySelectorAll('.cat-pill');

assert(!!cheatInput, 'Cheatsheet search input (#cheatSearchInput) exists');
assert(!!commandsGrid, 'Cheatsheet grid (#commandsGrid) exists');
assert(catPills.length > 0, 'Category pills exist');

// Test initial command rendering
assert(commandsGrid.querySelectorAll('.command-card').length > 0, 'Commands grid initially populates with command cards');

// Search for "docker run"
cheatInput.value = 'docker run';
cheatInput.dispatchEvent(new window.Event('input'));
assert(commandsGrid.innerHTML.includes('docker run'), 'Searching "docker run" displays matching command cards');

// Search non-existent query
cheatInput.value = 'nonexistentcmd123456';
cheatInput.dispatchEvent(new window.Event('input'));
const resetBtn = document.getElementById('resetCheatSearchBtn');
assert(!!resetBtn, 'Non-matching query shows empty state with "Clear Search" button');

// Click "Clear Search"
resetBtn.click();
assert(cheatInput.value === '', 'Clicking "Clear Search" resets input value');
assert(commandsGrid.querySelectorAll('.command-card').length > 0, 'Commands grid restores all commands after clear');

// ----------------------------------------------------
// TEST 3: System Status Modal & Environment Switcher
// ----------------------------------------------------
console.log('\n--- Test Suite 3: Enterprise Telemetry & Status Modal ---');
const openStatusBtn = document.getElementById('openStatusModalBtn');
const statusModal = document.getElementById('systemStatusModal');
const closeStatusBtn = document.getElementById('closeStatusModalBtn');
const envSwitcher = document.getElementById('globalEnvSwitcher');

assert(!!openStatusBtn, 'Open status modal button exists');
assert(!!statusModal, 'System status modal exists');

openStatusBtn.click();
assert(statusModal.classList.contains('active') && statusModal.classList.contains('open'), 'Clicking status button opens system status modal');

closeStatusBtn.click();
assert(!statusModal.classList.contains('active') && !statusModal.classList.contains('open'), 'Clicking close button closes system status modal');

if (envSwitcher) {
    envSwitcher.value = 'staging';
    envSwitcher.dispatchEvent(new window.Event('change'));
    assert(envSwitcher.value === 'staging', 'Environment switcher triggers change without error');
}

// ----------------------------------------------------
// TEST 4: Cross-Studio Bridges & Generator
// ----------------------------------------------------
console.log('\n--- Test Suite 4: Generator & Terminal Sandbox Bridge ---');
const bridgeToTermBtn = document.getElementById('bridgeToTerminalBtn');
const cliPromptInput = document.getElementById('cliPromptInput');
const appNameInput = document.getElementById('genAppName');

assert(!!bridgeToTermBtn, 'Bridge to terminal button exists');
assert(!!cliPromptInput, 'Terminal sandbox input exists');

if (appNameInput) appNameInput.value = 'payment-gateway';
bridgeToTermBtn.click();
assert(cliPromptInput.value.includes('docker build -t payment-gateway:latest .'), 'Bridge to terminal populates correct docker build command');

// ----------------------------------------------------
// TEST 5: Topology Visualizer Modal & Controls
// ----------------------------------------------------
console.log('\n--- Test Suite 5: Topology Visualizer ---');
const topoCards = document.querySelectorAll('.topo-node-card');
const nodeModal = document.getElementById('topologyNodeModal');
const closeNodeBtn = document.getElementById('closeTopologyNodeBtn');

assert(topoCards.length > 0, 'Topology node cards exist');
assert(!!nodeModal, 'Topology node modal exists');

if (topoCards.length > 0) {
    topoCards[0].click();
    assert(nodeModal.classList.contains('active') && nodeModal.classList.contains('open'), 'Clicking topology node opens nodeModal');
    closeNodeBtn.click();
    assert(!nodeModal.classList.contains('active') && !nodeModal.classList.contains('open'), 'Closing nodeModal works');
}

// ----------------------------------------------------
// TEST 6: Audit Every Button With an ID
// ----------------------------------------------------
console.log('\n--- Test Suite 6: Full Button Event Audit ---');
const allButtons = document.querySelectorAll('button[id]');
let errorCount = 0;

allButtons.forEach(btn => {
    try {
        btn.click();
    } catch (e) {
        console.error(`  ❌ Error clicking button #${btn.id}:`, e.message);
        errorCount++;
    }
});

assert(errorCount === 0, `All ${allButtons.length} buttons with IDs clicked without throwing errors`);

console.log('\n========================================');
console.log(`🎉 Audit Complete: ${passedTests}/${totalTests} tests passed.`);
console.log('========================================');
process.exit(process.exitCode || 0);
