// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFolderCollection on Isar {
  IsarCollection<Folder> get folders => this.collection();
}

const FolderSchema = CollectionSchema(
  name: r'Folder',
  id: 6793289488482879694,
  properties: {
    r'initDate': PropertySchema(
      id: 0,
      name: r'initDate',
      type: IsarType.dateTime,
    ),
    r'isPinned': PropertySchema(
      id: 1,
      name: r'isPinned',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'nameWords': PropertySchema(
      id: 3,
      name: r'nameWords',
      type: IsarType.stringList,
    ),
    r'notesCount': PropertySchema(
      id: 4,
      name: r'notesCount',
      type: IsarType.long,
    )
  },
  estimateSize: _folderEstimateSize,
  serialize: _folderSerialize,
  deserialize: _folderDeserialize,
  deserializeProp: _folderDeserializeProp,
  idName: r'id',
  indexes: {
    r'nameWords': IndexSchema(
      id: 8960882405442787957,
      name: r'nameWords',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nameWords',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _folderGetId,
  getLinks: _folderGetLinks,
  attach: _folderAttach,
  version: '3.1.0+1',
);

int _folderEstimateSize(
  Folder object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.nameWords.length * 3;
  {
    for (var i = 0; i < object.nameWords.length; i++) {
      final value = object.nameWords[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _folderSerialize(
  Folder object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.initDate);
  writer.writeBool(offsets[1], object.isPinned);
  writer.writeString(offsets[2], object.name);
  writer.writeStringList(offsets[3], object.nameWords);
  writer.writeLong(offsets[4], object.notesCount);
}

Folder _folderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Folder();
  object.id = id;
  object.initDate = reader.readDateTime(offsets[0]);
  object.isPinned = reader.readBool(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.notesCount = reader.readLong(offsets[4]);
  return object;
}

P _folderDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _folderGetId(Folder object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _folderGetLinks(Folder object) {
  return [];
}

void _folderAttach(IsarCollection<dynamic> col, Id id, Folder object) {
  object.id = id;
}

extension FolderQueryWhereSort on QueryBuilder<Folder, Folder, QWhere> {
  QueryBuilder<Folder, Folder, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhere> anyNameWordsElement() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'nameWords'),
      );
    });
  }
}

extension FolderQueryWhere on QueryBuilder<Folder, Folder, QWhereClause> {
  QueryBuilder<Folder, Folder, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> nameWordsElementEqualTo(
      String nameWordsElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nameWords',
        value: [nameWordsElement],
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> nameWordsElementNotEqualTo(
      String nameWordsElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nameWords',
              lower: [],
              upper: [nameWordsElement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nameWords',
              lower: [nameWordsElement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nameWords',
              lower: [nameWordsElement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nameWords',
              lower: [],
              upper: [nameWordsElement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> nameWordsElementGreaterThan(
    String nameWordsElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nameWords',
        lower: [nameWordsElement],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> nameWordsElementLessThan(
    String nameWordsElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nameWords',
        lower: [],
        upper: [nameWordsElement],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> nameWordsElementBetween(
    String lowerNameWordsElement,
    String upperNameWordsElement, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nameWords',
        lower: [lowerNameWordsElement],
        includeLower: includeLower,
        upper: [upperNameWordsElement],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> nameWordsElementStartsWith(
      String NameWordsElementPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nameWords',
        lower: [NameWordsElementPrefix],
        upper: ['$NameWordsElementPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> nameWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nameWords',
        value: [''],
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterWhereClause> nameWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'nameWords',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'nameWords',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'nameWords',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'nameWords',
              upper: [''],
            ));
      }
    });
  }
}

extension FolderQueryFilter on QueryBuilder<Folder, Folder, QFilterCondition> {
  QueryBuilder<Folder, Folder, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> initDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> initDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'initDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> initDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'initDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> initDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'initDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> isPinnedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPinned',
        value: value,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition>
      nameWordsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition>
      nameWordsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition>
      nameWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameWords',
        value: '',
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition>
      nameWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameWords',
        value: '',
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameWords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameWords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameWords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameWords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition>
      nameWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> nameWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nameWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> notesCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> notesCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> notesCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Folder, Folder, QAfterFilterCondition> notesCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notesCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FolderQueryObject on QueryBuilder<Folder, Folder, QFilterCondition> {}

extension FolderQueryLinks on QueryBuilder<Folder, Folder, QFilterCondition> {}

extension FolderQuerySortBy on QueryBuilder<Folder, Folder, QSortBy> {
  QueryBuilder<Folder, Folder, QAfterSortBy> sortByInitDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initDate', Sort.asc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> sortByInitDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initDate', Sort.desc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> sortByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> sortByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> sortByNotesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesCount', Sort.asc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> sortByNotesCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesCount', Sort.desc);
    });
  }
}

extension FolderQuerySortThenBy on QueryBuilder<Folder, Folder, QSortThenBy> {
  QueryBuilder<Folder, Folder, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> thenByInitDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initDate', Sort.asc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> thenByInitDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initDate', Sort.desc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> thenByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> thenByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> thenByNotesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesCount', Sort.asc);
    });
  }

  QueryBuilder<Folder, Folder, QAfterSortBy> thenByNotesCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesCount', Sort.desc);
    });
  }
}

extension FolderQueryWhereDistinct on QueryBuilder<Folder, Folder, QDistinct> {
  QueryBuilder<Folder, Folder, QDistinct> distinctByInitDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'initDate');
    });
  }

  QueryBuilder<Folder, Folder, QDistinct> distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<Folder, Folder, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Folder, Folder, QDistinct> distinctByNameWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameWords');
    });
  }

  QueryBuilder<Folder, Folder, QDistinct> distinctByNotesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notesCount');
    });
  }
}

extension FolderQueryProperty on QueryBuilder<Folder, Folder, QQueryProperty> {
  QueryBuilder<Folder, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Folder, DateTime, QQueryOperations> initDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'initDate');
    });
  }

  QueryBuilder<Folder, bool, QQueryOperations> isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<Folder, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Folder, List<String>, QQueryOperations> nameWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameWords');
    });
  }

  QueryBuilder<Folder, int, QQueryOperations> notesCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notesCount');
    });
  }
}
