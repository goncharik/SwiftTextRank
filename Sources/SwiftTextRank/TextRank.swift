import Foundation

final class TextRank<T: Hashable> {
    typealias Nodes = [T: Float]
    typealias Edges = [T: Float]
    typealias Graph = [T: [T]]
    typealias Matrix = [T: Nodes]

    private var nodes = Nodes()
    private var outlinks = Edges()
    private var graph = Graph()
    private var weights = Matrix()

    let score: Float = 0.15
    let damping: Float = 0.85
    let convergence: Float = 0.01

    func add(edge from: T, to: T, weight: Float = 1.0) {
        if from == to { return }

        add(node: from, to: to)
        add(weigth: from, to: to, weight: weight)
        increment(outlinks: from)
    }

    func build() -> Nodes {
        var rankedNodes = pageRank(nodes)
        while !isConvergent(rankedNodes, nodes: nodes) {
            nodes = rankedNodes
            rankedNodes = pageRank(nodes)
        }
        return nodes
    }

    // MARK: - Main algorithm

    private func pageRank(_ nodes: Nodes) -> Nodes {
        var vertexes = Nodes()
        for (node, links) in graph {
            let score: Float = self.score(for: node, links)
            vertexes[node] = (1 - damping / Float(nodes.count)) + damping * score
        }
        return vertexes
    }

    private func isConvergent(_ current: Nodes, nodes: Nodes) -> Bool {
        if current == nodes { return true }

        let total: Float = nodes.reduce(0.0) {
            return $0 + pow((current[$1.key] ?? 0.0) - $1.value, 2)
        }
        return sqrtf(total / Float(current.count)) < convergence
    }

    // MARK: - Private helpers

    private func score(for node: T, _ links: [T]) -> Float {
        links.reduce(Float(0.0)) {
            let nodes: Float = self.nodes[$1] ?? 0.0
            let outlinks: Float = self.outlinks[$1] ?? 0.0
            let weights: Float = self.weights[$1]?[node] ?? 0.0
            return $0 + nodes / outlinks * weights
        }
    }

    private func increment(outlinks source: T) {
        if let links = outlinks[source] {
            outlinks[source] = links + 1
        } else {
            outlinks[source] = 1
        }
    }

    private func add(node from: T, to: T) {
        if var node = graph[to] {
            node.append(from)
            graph[to] = node
        } else {
            graph[to] = [from]
        }

        nodes[from] = score
        nodes[to] = score
    }

    private func add(weigth from: T, to: T, weight: Float) {
        if weights[from] == nil {
            weights[from] = Nodes()
            weights[from]![to] = weight
        } else {
            weights[from]![to] = weight
        }
    }
}
