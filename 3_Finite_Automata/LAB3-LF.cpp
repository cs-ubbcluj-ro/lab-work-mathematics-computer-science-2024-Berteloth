#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <set>
#include <map>
#include <vector>

using namespace std;

struct FiniteAutomaton {
    set<string> states;
    set<string> alphabet;
    map<pair<string, string>, set<string>> transitions;
    string initialState;
    set<string> finalStates;
};

FiniteAutomaton parseFA(const string& filename) {
    FiniteAutomaton fa;
    ifstream file(filename);
    string line, section;

    if (!file) {
        cerr << "File not found!" << endl;
        return fa;
    }

    while (getline(file, line)) {
        if (line.empty()) continue;

        if (line == "#states") {
            section = "states";
        } else if (line == "#alphabet") {
            section = "alphabet";
        } else if (line == "#transitions") {
            section = "transitions";
        } else if (line == "#initial") {
            section = "initial";
        } else if (line == "#final") {
            section = "final";
        } else {
            istringstream iss(line);
            if (section == "states") {
                string state;
                while (iss >> state) {
                    fa.states.insert(state);
                }
            } else if (section == "alphabet") {
                string symbol;
                while (iss >> symbol) {
                    fa.alphabet.insert(symbol);
                }
            } else if (section == "transitions") {
                size_t commaPos = line.find(',');
                size_t arrowPos = line.find("->");

                if (commaPos != string::npos && arrowPos != std::string::npos) {
                    string src = line.substr(0, commaPos);
                    string symbol = line.substr(commaPos + 1, arrowPos - commaPos - 1);
                    string dest = line.substr(arrowPos + 2);

                    src.erase(src.find_last_not_of(" \n\r\t") + 1);
                    symbol.erase(symbol.find_last_not_of(" \n\r\t") + 1);
                    dest.erase(dest.find_last_not_of(" \n\r\t") + 1);

                    fa.transitions[{src, symbol}].insert(dest);

                    cerr << "Parsed transition: " << src << ", " << symbol << " -> " << dest << endl;
                } else {
                    cerr << "Error parsing transition: " << line << endl;
                }
            } else if (section == "initial") {
                iss >> fa.initialState;
            } else if (section == "final") {
                string finalState;
                while (iss >> finalState) {
                    fa.finalStates.insert(finalState);
                }
            }
        }
    }
    return fa;
}

void displayFA(const FiniteAutomaton& fa) {
    cout << "Set of States: ";
    for (const auto& state : fa.states) {
        cout << state << " ";
    }
    cout << "\nAlphabet: ";
    for (const auto& symbol : fa.alphabet) {
        cout << symbol << " ";
    }
    cout << "\nTransitions:" << endl;

    for (const auto& transition : fa.transitions) {
        const pair<string, string>& key = transition.first;
        const set<string>& dests = transition.second;

        cout << "  d(" << key.first << ", '" << key.second << "') -> ";
        for (const auto& dest : dests) {
            cout << dest << " ";
        }
        cout << endl;
    }

    cout << "Initial State: " << fa.initialState << endl;
    cout << "Set of Final States: ";
    for (const auto& finalState : fa.finalStates) {
        cout << finalState << " ";
    }
    cout << endl;
}


int main() {
    string filename = "FA.in";
    FiniteAutomaton fa = parseFA(filename);
    displayFA(fa);
    return 0;
}
