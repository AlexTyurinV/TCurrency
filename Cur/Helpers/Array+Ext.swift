//
//  Array+Ext.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Foundation

public extension Array where Element: Hashable {

    private func permute(list: [Element]) -> Set<[Element]> {
        func permute(fromList: [Element], toList: [Element], set: inout Set<[Element]>) {
            if toList.count >= 1 && toList.count < 4 {
                set.insert(toList)
            }
            if !fromList.isEmpty {
                for (index, item) in fromList.enumerated() {
                    var newFrom = fromList
                    newFrom.remove(at: index)
                    permute(fromList: newFrom, toList: toList + [item], set: &set)
                }
            }
        }

        var set = Set<[Element]>()
        permute(fromList: list, toList:[], set: &set)
        return set
    }

    private func allPossibleCombinations() -> [[Element]] {
        var output: [[Element]] = [[]]
        for groupSize in 1...self.count {
            for (index1, item1) in self.enumerated() {
                var group = [item1]
                for (index2, item2) in self.enumerated() {
                    if group.count < groupSize {
                        if index2 > index1 {
                            group.append(item2)
                            if group.count == groupSize {
                                output.append(group)
                                group = [item1]
                                continue
                            }
                        }
                    } else {
                        break
                    }
                }
                if group.count == groupSize {
                    output.append(group)
                }
            }
        }
        return output
    }

    func combinationFast(prefix: Element, sufix: Element) -> [[Element]] {
        let list = self.filter {
            $0 != prefix && $0 != sufix
        }
        return list.allPossibleCombinations().map { road in
            [[prefix], road, [sufix]].flatMap { $0 }
        }
    }

    func combination(prefix: Element, sufix: Element) -> [[Element]] {
        let list = self.filter {
            $0 != prefix && $0 != sufix
        }
        return permute(list: list).map { road in
            [[prefix], road, [sufix]].flatMap { $0 }
        }
    }
}
